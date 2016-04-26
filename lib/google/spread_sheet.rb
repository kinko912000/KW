require 'google/drive'
module Google
  class SpreadSheet < Google::Drive
    attr_accessor :title, :session, :client, :file, :sheet

    def initialize(sheet_key = nil)
      super
      @sheet = nil
      @file =  @session.spreadsheet_by_key(sheet_key) if sheet_key.present?
    end

    def set_sheet_by_title(sheet_title)
      ### NOTE: 毎回sheetを呼び出すたびにapiを叩かないように保持する
      @sheet = @file.worksheet_by_title(sheet_title)
    end

    def set_file_by_title(file_title)
      @file = @session.file_by_title(file_title)
    end
  end
end
