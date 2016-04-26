module Google
  class Drive
    GOOGLE_DRIVE_CLIENT_ID = ENV['GOOGLE_DRIVE_CLIENT_ID']
    GOOGLE_DRIVE_CLIENT_SECRET = ENV['GOOGLE_DRIVE_CLIENT_SECRET']
    AUTH_SCOPE = 'https://www.googleapis.com/auth/drive https://spreadsheets.google.com/feeds/'
    REDIRECT_URL = 'urn:ietf:wg:oauth:2.0:oob'
    @@google_drive_refresh_token = ENV['GOOGLE_DRIVE_REFRESH_TOKEN']

    attr_accessor :session, :client

    def initialize(sheet_key = nil)
      @client = Google::APIClient.new
      @session = create_session
    end

    def refresh_token!
      @@google_drive_refresh_token = @client.authorization.refresh_token
    end

    private
    def create_session
      auth = @client.authorization
      auth.client_id = GOOGLE_DRIVE_CLIENT_ID
      auth.client_secret = GOOGLE_DRIVE_CLIENT_SECRET
      auth.scope = AUTH_SCOPE
      auth.redirect_uri = REDIRECT_URL
      auth.refresh_token = @@google_drive_refresh_token
      begin
        auth.fetch_access_token!
      rescue Signet::AuthorizationError
        ### NOTE: トラブル対応用のコードです。
        # 通常はrefresh_tokenを利用すれば認可されますが、
        # 何らかの原因によりrefresh_tokenが無効になっていたときの対策として
        # 手動でログインできる方法を残しています
        puts('1. Open this page:\n%s\n\n' % auth.authorization_uri)
        puts('2. Enter the authorization code shown in the page: ')
        auth.code = $stdin.gets.chomp
        auth.fetch_access_token!
      end
      refresh_token!
      GoogleDrive.login_with_oauth(auth.access_token)
    end
  end
end