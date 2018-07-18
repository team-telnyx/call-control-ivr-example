module CallControl
  class TelnyxClient
    include HTTParty
    base_uri "https://api.telnyx.com"
    headers "Accept" => "application/json"

    def initialize
      Rails.logger.debug(ENV["TELNYX_API_KEY"])
      Rails.logger.debug(ENV["TELNYX_API_SECRET"])

      @auth = {username: ENV["TELNYX_API_KEY"], password: ENV["TELNYX_API_SECRET"]}
    end

    def answer_call(call_control_id)
      call_action("answer", call_control_id)
    end

    def hangup_call(call_control_id)
      call_action("hangup", call_control_id)
    end

    def transfer_call(call_control_id, from, to)
      body = {from: from, to: to}
      call_action("transfer", call_control_id, body)
    end

    def play_audio(call_control_id, audio_url)
      body = {audio_url: audio_url}
      call_action("playback_start", call_control_id, body)
    end

    def gather(call_control_id, audio_url, opts = {})
      body = {audio_url: audio_url}
      body.merge!(opts)
      call_action("gather", call_control_id, body)
    end

    private

    def call_action(action, call_control_id, body = nil)
      options = {body: body.to_json, basic_auth: @auth}
      Rails.logger.info("Making #{action} request to Telnyx. Body: #{body.inspect}")
      response = self.class.post("/calls/#{call_control_id}/actions/#{action}", options)
      Rails.logger.info(response.inspect)
    end
  end
end
