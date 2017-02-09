# monkeypatch to get around paperclip's horrible spoof detector
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

Paperclip.interpolates(:file_number) do |attachment, style|
  attachment.instance.unique_file_number
end
