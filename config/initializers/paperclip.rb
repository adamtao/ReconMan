# monkeypatch to get around paperclip's horrible spoof detector
require 'paperclip/media_type_spoof_detector'

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
  class UrlGenerator
    private
    def escape_url(url)
      if url.respond_to?(:escape)
        url.escape
      else
        ::Addressable::URI.parse(url).normalize.to_str.gsub(escape_regex){|m| "%#{m.ord.to_s(16).upcase}" }
      end
    end
  end
end

Paperclip.interpolates(:file_number) do |attachment, style|
  attachment.instance.unique_file_number
end
