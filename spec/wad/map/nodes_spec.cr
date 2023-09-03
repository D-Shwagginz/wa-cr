require "../../spec_helper"

describe WAD::Map::Nodes, tags: "map" do
  it "should properly set map nodes", tags: "nodes" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    node_check(mywad, "E1M1", 89, 128, -3200, -64, 128)
    node_check(mywad, "E1M6", 293, 0, -64, -128, 0)
    node_check(mywad, "E2M2", 499, -32, 3680, 0, -32)
    node_check(mywad, "E2M6", 63, 1024, 2560, 192, 0)
  end
end
