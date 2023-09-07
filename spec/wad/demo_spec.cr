require "../spec_helper"

describe WAD::Demo, tags: "demos" do
  it "should properly set the demos" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.demos.size.should eq 3

    my_wad.demos.values[0].game_version.should eq 109
    my_wad.demos.values[0].skill_level.should eq 3
    my_wad.demos.values[0].player4.should eq false
    my_wad.demos.values[0].input_actions[0].movement_forward_back.should eq -40
    my_wad.demos.values[0].input_actions[0].strafing.should eq 0
    my_wad.demos.values[0].input_actions[0].turning.should eq -3
    my_wad.demos.values[0].input_actions[0].action.should eq 0
    my_wad.demos.values[0].input_actions[-1].movement_forward_back.should eq 0
    my_wad.demos.values[0].input_actions[-1].strafing.should eq 0
    my_wad.demos.values[0].input_actions[-1].turning.should eq 0
    my_wad.demos.values[0].input_actions[-1].action.should eq 0
  end
end
