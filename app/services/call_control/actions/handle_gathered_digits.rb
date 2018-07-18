module CallControl::Actions
  class HandleGatheredDigits < Command
    def execute event, call
      case event.require(:payload).require(:digits)
      when "1"
        telnyx_client.transfer_call(call.call_control_id, call.to, ENV['SUPPORT_PHONE_NUMBER'])
      when "2"
        telnyx_client.hangup_call(call.call_control_id)
      end
    end

    def valid? event, call
      call.awaiting_gather_end?
    end
  end
end
