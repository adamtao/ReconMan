require 'rails_helper'

describe "lenders/show.html.erb" do

  context "merge form" do
    before do
      @lender1 = create(:lender)
      @lender2 = create(:lender)
      assign(:lender, @lender1)
    end

    context "for admins" do

      before do
        @current_user = build_stubbed(:user, :admin)
        allow(view).to receive_messages(:current_user => @current_user)

        render
      end

      it "is present" do
        expect(rendered).to have_css("form#merge_lender")
      end

      it "does not show itself in the dropdown" do
        merge_form = Capybara.string(rendered).find("form#merge_lender")
        dropdown = merge_form.find("select#merge_with_id")

        expect(dropdown).not_to have_content(@lender1.name)
      end

      it "shows other lenders in the dropdown" do
        merge_form = Capybara.string(rendered).find("form#merge_lender")
        dropdown = merge_form.find("select#merge_with_id")

        expect(dropdown).to have_content(@lender2.name)
      end
    end

    context "for processors" do

      before do
        @current_user = build_stubbed(:user, :processor)
        allow(view).to receive_messages(:current_user => @current_user)

        render
      end

      it "is NOT present" do
        expect(rendered).not_to have_css("form#merge_lender")
      end
    end
  end

end

