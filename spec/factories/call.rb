FactoryBot.define do
  factory :call do
    from "+35319605860"
    to  "+35319605899"
    status "initiated"
    call_leg_id "some-call-leg-id"
    call_control_id "AgDIxmoRX6QMuaIj_uXRXnPAXP0QlNfXczRrZvZakpWxBlpw48KyZQ=="
  end
end
