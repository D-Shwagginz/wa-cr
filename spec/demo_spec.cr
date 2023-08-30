require "./spec_helper"

describe WAD::Demo do
  it "should properly set the demos" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.demos.size.should eq 3

    mywad.demos[0].game_version.should eq 109
    mywad.demos[0].skill_level.should eq 3
    mywad.demos[0].player4.should eq false
    mywad.demos[0].input_actions[0].movement_forward_back.should eq -40
    mywad.demos[0].input_actions[0].strafing.should eq 0
    mywad.demos[0].input_actions[0].turning.should eq -3
    mywad.demos[0].input_actions[0].action.should eq 0
    mywad.demos[0].input_actions[-1].movement_forward_back.should eq 0
    mywad.demos[0].input_actions[-1].strafing.should eq 0
    mywad.demos[0].input_actions[-1].turning.should eq 0
    mywad.demos[0].input_actions[-1].action.should eq 0
  end
end
