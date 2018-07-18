require "rails_helper"

describe CallControl::TelnyxClient do
  let(:client) {CallControl::TelnyxClient.new}
  let(:call_control_id) {SecureRandom.uuid}

  it "should properly call answer action" do
    stub_telnyx_request call_control_id, "answer"
    client.answer_call call_control_id
  end

  it "should properly call hangup action" do
    stub_telnyx_request call_control_id, "hangup"
    client.hangup_call call_control_id
  end

  it "should properly call transfer action" do
    body = {from: "from who", to: "to who"}.to_json
    stub_telnyx_request call_control_id, "transfer", body
    client.transfer_call call_control_id, "from who", "to who"
  end

  it "should properly call playback_start action" do
    body = {audio_url: "some-url"}.to_json
    stub_telnyx_request call_control_id, "playback_start", body
    client.play_audio call_control_id, "some-url"
  end

  it "should properly call gather action" do
    body = {audio_url: "some-url", min: 1, max: 1, timeout: 5_000}.to_json
    stub_telnyx_request call_control_id, "gather", body
    client.gather call_control_id, "some-url", {min: 1, max: 1, timeout: 5_000}
  end

  def stub_telnyx_request(call_control_id, action, body = "null")
    encoded = Base64.strict_encode64("#{ENV["TELNYX_API_KEY"]}:#{ENV["TELNYX_API_SECRET"]}")
    headers = {"Accept"=>"application/json", "Authorization"=>"Basic #{encoded}"}

    stub_request(:post, "https://api.telnyx.com/calls/#{call_control_id}/actions/#{action}")
      .with(body: body, headers: headers)
      .to_return(status: 200, body: "", headers: {})
  end
end
