module CallControl::Actions
  class Command
    def perform event
      call = load_call(event)
      if valid?(event, call)
        before_execute(event, call)
        execute(event, call)
        update_call_status(call)
      end
    end

    def before_execute(event, call)
      call.update_status(event[:event_type]) if call
    end

    def execute event, call

    end

    def call_status_after_execution

    end

    def load_call event
      call_leg_id = event.require(:payload).require(:call_leg_id)
      ::Call.find_by!(call_leg_id: call_leg_id)
    end

    def valid? event, call
      true
    end

    def telnyx_client
      @telnyx_client ||= ::CallControl::TelnyxClient.new
    end

    private
    def update_call_status(call)
      if call_status_after_execution
        call.status = call_status_after_execution
        call.save!
      end
    end
  end
end
