require 'rails_helper'

describe Call do
  it "should properly build it" do
    event = JSON.parse(file_fixture("events/call_initiated.json").read, {symbolize_names: true})
    payload = event[:payload]
    call = Call.build(event)

    expect(call.status).to eq("initiated")
    expect(call.from).to eq(payload[:from])
    expect(call.to).to eq(payload[:to])
    expect(call.call_control_id).to eq(payload[:call_control_id])
  end

  context "updating call status" do
    before do
      @call = build(:call)
    end
    
    it "should return false if event type is unknown" do
      expect(@call.update_status("unknown")).to eq(false)
    end

    it "should return false if status translation is the same" do
      expect(@call.update_status("call_initiated")).to eq(false)
    end

    it "should update status if it's different" do
      expect(@call.initiated?).to be(true)
      expect(@call.update_status("call_answered")).to eq(true)
      expect(@call.answered?).to be(true)
    end
  end
end
