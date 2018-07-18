module CallControl
  class EventHandler
    EVENT_TO_ACTION_MAP = {
      "call_initiated" => Actions::AnswerCall,
      "call_answered" => Actions::GatherDigits,
      "gather_ended" => Actions::HandleGatheredDigits,
      "call_hangup" => Actions::FinishCall,
    }

    def self.handle event
      Rails.logger.debug(event)
      action = EVENT_TO_ACTION_MAP[event[:event_type]]
      action.new.perform(event) unless action.nil?
    end
  end
end
