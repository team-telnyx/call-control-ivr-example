require 'rails_helper'

describe EventsController do
  after do
    assert_response :success
  end

  context "call_initiated" do
    before do
      @params = JSON.parse(file_fixture("events/call_initiated.json").read, {symbolize_names: true})
      @call_control_id = @params[:payload][:call_control_id]
      @call = Call.build(@params)
      @call.save!
    end

    after do
      @call.reload
      expect(@call.status).to eq("initiated")
    end

    it "should answer call and change status to initiated" do
      expect_any_instance_of(CallControl::TelnyxClient).to receive(:answer_call).with(@call_control_id)
      post :handle_event, params: @params
    end
  end

  context "call_answered" do
    before do
      @params = JSON.parse(file_fixture("events/call_answered.json").read, {symbolize_names: true})
      @call_control_id = @params[:payload][:call_control_id]
      @call = Call.build(@params)
      @call.save!
    end

    after do
      @call.reload
      expect(@call.status).to eq("awaiting_gather_end")
    end

    it "should issue gather command" do
      expect_any_instance_of(CallControl::TelnyxClient).to receive(:gather)
        .with(@call_control_id, ENV['IVR_MENU_URL'], {max: 1, timeout: 10_000, valid_digits: "12"})
      post :handle_event, params: @params
    end
  end

  context "gather_ended" do
    before do
      @params = JSON.parse(file_fixture("events/gather_ended.json").read, {symbolize_names: true})
      @call_control_id = @params[:payload][:call_control_id]

      call = Call.build(@params)
      call.status = "awaiting_gather_end"
      call.save!
    end

    it "should transfer call to support when digit is 1" do
      @params[:payload][:digits] = "1"
      expect_any_instance_of(CallControl::TelnyxClient).to receive(:transfer_call)
        .with(@call_control_id, @params[:payload][:to], ENV['SUPPORT_PHONE_NUMBER'])
      post :handle_event, params: @params
    end

    it "should hangup call when digit is 2" do
      @params[:payload][:digits] = "2"
      expect_any_instance_of(CallControl::TelnyxClient).to receive(:hangup_call).with(@call_control_id)
      post :handle_event, params: @params
    end
  end

  context "dtmf" do
    before do
      @params = JSON.parse(file_fixture("events/dtmf.json").read, {symbolize_names: true})
      @call_control_id = @params[:payload][:call_control_id]

      call = Call.build(@params)
      call.status = "initiated"
      call.save!
    end

    it "should do nothing" do
      expect_any_instance_of(CallControl::TelnyxClient).not_to receive(:transfer_call)
      @params[:payload][:digit] = "1"
      post :handle_event, params: @params
    end
  end
end
