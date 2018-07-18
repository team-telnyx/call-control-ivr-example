module CallControl::Actions
  class GatherDigits < Command
    def execute event, call
      telnyx_client.gather(call.call_control_id, audio_url, max: 1, timeout: 10_000, valid_digits: "12")
    end

    def call_status_after_execution
      "awaiting_gather_end"
    end

    def valid? event, call
      call.incoming?
    end

    private
      def audio_url
        ENV['IVR_MENU_URL'] || "https://#{ENV['APP_NAME']}.herokuapp.com/files/ivr_menu"
      end
  end
end
