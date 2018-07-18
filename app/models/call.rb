class Call < ApplicationRecord
  EVENT_TYPE_TO_STATUS_MAPPING = {
    "call_initiated" => "initiated",
    "call_answered" => "answered",
    "call_bridged" => "bridged",
    "call_hangup" => "finished",
    "playback_started" => "awaiting_gather_end",
    "gather_ended" => "gather_ended"
  }

  EVENT_TYPE_TO_STATUS_MAPPING.values.each do |call_status|
    define_method :"#{call_status}?" do
      self.status == call_status
    end
  end

  validates :from, :to, :call_control_id, :call_leg_id, :status, presence: true
  validates_inclusion_of :status, :in => EVENT_TYPE_TO_STATUS_MAPPING.values

  def self.build(event)
    payload = event[:payload]
    status = EVENT_TYPE_TO_STATUS_MAPPING[event[:event_type]]
    Call.new(
      from: payload[:from],
      to: payload[:to],
      call_control_id: payload[:call_control_id],
      call_leg_id: payload[:call_leg_id],
      status: status
    )
  end

  def update_status event_type
    new_status = EVENT_TYPE_TO_STATUS_MAPPING[event_type]
    return false if new_status.nil? || self.status == new_status
    self.status = new_status
    self.save
  end
end
