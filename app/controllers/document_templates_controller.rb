class DocumentTemplatesController < ApplicationController
  before_action :set_document_template, only: [:show, :edit, :update, :destroy]

  def index
    @document_templates = DocumentTemplate.all.order("doctype")
  end

  def new
    @document_template = DocumentTemplate.new(layout: "letterhead")
  end

  def edit
  end

  def create
    @document_template = DocumentTemplate.new(document_template_params)
    @document_template.creator = current_user
    respond_to do |format|
      if @document_template.save
        format.html { redirect_to document_templates_path, notice: 'Template was successfully created.' }
        format.json { render :show, status: :created, location: @document_template }
      else
        format.html { render :new }
        format.json { render json: @document_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @document_template.modifier = current_user
    respond_to do |format|
      if @document_template.update(document_template_params)
        format.html { redirect_to document_templates_path, notice: 'Template was successfully updated.' }
        format.json { render :show, status: :ok, location: @document_template }
      else
        format.html { render :edit }
        format.json { render json: @document_template.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_document_template
      @document_template = DocumentTemplate.find(params[:id])
    end

    def document_template_params
      params.require(:document_template).permit(:doctype, :layout, :content)
    end
end
