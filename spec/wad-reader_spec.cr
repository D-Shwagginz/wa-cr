require "./spec_helper"

describe WAD do
  it "should properly set the wad type" do
    mywad = WAD.read("./rsrc/DOOM.WAD")
    (mywad.type == WAD::Type::Internal).should be_true
  end

  it "should properly set map things" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M1" }.things[0].x_position.should eq 1056
    mywad.maps.find! { |m| m.name == "E2M2" }.things[10].y_position.should eq 3168
    mywad.maps.find! { |m| m.name == "E3M3" }.things[20].angle_facing.should eq 0
    mywad.maps.find! { |m| m.name == "E3M3" }.things[20].thing_type.should eq 2047
    mywad.maps.find! { |m| m.name == "E2M5" }.things[135].flags.should eq 4
  end

  it "should properly set map linedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M4" }.linedefs[293].back_sidedef.should eq 316
    mywad.maps.find! { |m| m.name == "E2M6" }.linedefs[823].front_sidedef.should eq 1004
    mywad.maps.find! { |m| m.name == "E3M1" }.linedefs[93].end_vertex.should eq 87
    mywad.maps.find! { |m| m.name == "E2M8" }.linedefs[179].special_type.should eq 0
    mywad.maps.find! { |m| m.name == "E1M9" }.linedefs[202].sector_tag.should eq 12
  end

  it "should properly set map sidedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E3M2" }.sidedefs[210].x_offset.should eq 113
    mywad.maps.find! { |m| m.name == "E1M6" }.sidedefs[1523].name_tex_up.should eq "COMPUTE2"
    mywad.maps.find! { |m| m.name == "E2M1" }.sidedefs[350].name_tex_mid.should eq "SLADWALL"
    mywad.maps.find! { |m| m.name == "E3M6" }.sidedefs[52].facing_sector_num.should eq 4
    mywad.maps.find! { |m| m.name == "E2M4" }.sidedefs[1438].name_tex_low.should eq "GRAYTALL"
  end

  it "should properly set map vertexes" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M7" }.vertexes[695].x_position.should eq 1664
    mywad.maps.find! { |m| m.name == "E2M8" }.vertexes[78].y_position.should eq -224
    mywad.maps.find! { |m| m.name == "E3M5" }.vertexes[1198].x_position.should eq -16
    mywad.maps.find! { |m| m.name == "E1M3" }.vertexes[382].y_position.should eq -2304
    mywad.maps.find! { |m| m.name == "E3M2" }.vertexes[0].x_position.should eq 1984
  end

  it "should properly set map segs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M3" }.segs[531].angle.should eq 16384
    mywad.maps.find! { |m| m.name == "E2M4" }.segs[1003].direction.should eq 1
    mywad.maps.find! { |m| m.name == "E3M6" }.segs[163].offset.should eq 146
    mywad.maps.find! { |m| m.name == "E1M2" }.segs[1323].start_vertex_num.should eq 545
    mywad.maps.find! { |m| m.name == "E3M9" }.segs[227].end_vertex_num.should eq 187
  end

  it "should properly set map ssectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M2" }.ssectors[100].seg_count.should eq 4
    mywad.maps.find! { |m| m.name == "E2M4" }.ssectors[81].first_seg_num.should eq 267
    mywad.maps.find! { |m| m.name == "E3M2" }.ssectors[237].seg_count.should eq 1
    mywad.maps.find! { |m| m.name == "E2M1" }.ssectors[0].seg_count.should eq 5
    mywad.maps.find! { |m| m.name == "E2M5" }.ssectors[338].first_seg_num.should eq 1003
  end

  it "should properly set map nodes" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E2M4" }.nodes[284].right_bound_box[1].should eq -1152
    mywad.maps.find! { |m| m.name == "E1M3" }.nodes[303].y_coord.should eq -2112
    mywad.maps.find! { |m| m.name == "E2M5" }.nodes[473].x_coord.should eq -1920
    mywad.maps.find! { |m| m.name == "E1M9" }.nodes[286].left_bound_box[3].should eq 2688
    mywad.maps.find! { |m| m.name == "E3M2" }.nodes[110].right_child.should eq 103
  end

  it "should properly set map sectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M5" }.sectors[29].floor_height.should eq -176
    mywad.maps.find! { |m| m.name == "E2M4" }.sectors[178].name_tex_floor.should eq "BLOOD3"
    mywad.maps.find! { |m| m.name == "E3M8" }.sectors[7].ceiling_height.should eq 128
    mywad.maps.find! { |m| m.name == "E3M3" }.sectors[97].light_level.should eq 128
    mywad.maps.find! { |m| m.name == "E2M2" }.sectors[182].special_type.should eq 0
  end

  it "should properly set map reject" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M2" }.reject[1, 2].should eq false
    mywad.maps.find! { |m| m.name == "E2M3" }.reject[32, 52].should eq true
    mywad.maps.find! { |m| m.name == "E3M1" }.reject[0, 9].should eq true
  end

  it "should properly set map blockmap" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E2M1" }.blockmap.header.grid_origin_x.should eq -296
    mywad.maps.find! { |m| m.name == "E3M5" }.blockmap.header.num_of_rows.should eq 37
    mywad.maps.find! { |m| m.name == "E1M8" }.blockmap.offsets[3].should eq 2922
    mywad.maps.find! { |m| m.name == "E2M5" }.blockmap.blocklists[5].linedefs_in_block[1].should eq 480
    mywad.maps.find! { |m| m.name == "E3M1" }.blockmap.blocklists[8].linedefs_in_block[2].should eq 1
  end

  it "should properly set pc sounds" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.pcsounds.find! { |m| m.name == "DPSAWIDL" }.samples[3].should eq 63
    mywad.pcsounds.find! { |m| m.name == "DPDOROPN" }.samples[23].should eq 24
    mywad.pcsounds.find! { |m| m.name == "DPSTNMOV" }.format_num.should eq 0
    mywad.pcsounds.find! { |m| m.name == "DPSWTCHX" }.samples_num.should eq 8
    mywad.pcsounds.find! { |m| m.name == "DPSLOP" }.samples[19].should eq 12
  end

  it "should properly set sounds" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.sounds.find! { |m| m.name == "DSSHOTGN" }.format_num.should eq 3
    mywad.sounds.find! { |m| m.name == "DSSAWIDL" }.sample_rate.should eq 11025
    mywad.sounds.find! { |m| m.name == "DSRLAUNC" }.samples_num.should eq 15483
    mywad.sounds.find! { |m| m.name == "DSSWTCHX" }.samples[0].should eq 126
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[0].should eq 126
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[2].should eq 125
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[3].should eq 127
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[4].should eq 128
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[11].should eq 129
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-2].should eq 129
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-3].should eq 128
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-4].should eq 128
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[0].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[2].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[3].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-2].should eq 122
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-3].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-4].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[0].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[1].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[2].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[3].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-1].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-2].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-3].should eq 124
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-4].should eq 124
  end

  it "should properly create sound file" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    File.open("./rsrc/spectest.wav", "w+") do |io|
      mywad.sounds.find! { |m| m.name == "DSPISTOL" }.to_wav(io)
    end
    File.exists?("./rsrc/spectest.wav").should be_true
    File.delete("./rsrc/spectest.wav")
  end

  it "should properly read music file" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.music.find! { |m| m.name == "D_E1M5" }.identifier.should eq "MUS\u001A"
    mywad.music.find! { |m| m.name == "D_E3M2" }.identifier.should eq "MUS\u001A"
    mywad.music.find! { |m| m.name == "D_E2M8" }.score_len.should eq 45988
    mywad.music.find! { |m| m.name == "D_BUNNY" }.score_start.should eq 50
    mywad.music.find! { |m| m.name == "D_E2M1" }.channels.should eq 6
  end

  it "should properly set the genmidi" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.genmidi.header.should eq "#OPL_II#"
    mywad.genmidi.instr_datas[0].header[0].should eq 0
    mywad.genmidi.instr_datas[27].voice1_data[2].should eq 50
    mywad.genmidi.instr_datas[172].voice2_data[-1].should eq 0
  end

  it "should properly set the dmxgus" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.dmxgus.instr_datas[0].patch.should eq 0
    mywad.dmxgus.instr_datas[2].c_k.should eq 1
    mywad.dmxgus.instr_datas[5].filename.should eq "epiano2"
    mywad.dmxgus.instr_datas[158].b_k.should eq 128
    mywad.dmxgus.instr_datas[189].patch.should eq 215
    mywad.dmxgus.instr_datas[50].d_k.should eq 50
    mywad.dmxgus.instr_datas[72].a_k.should eq 73
  end

  it "should properly set the playpal" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.playpal.pallets[0].colors[0].r.should eq 0
    mywad.playpal.pallets[0].colors[0].g.should eq 0
    mywad.playpal.pallets[0].colors[0].b.should eq 0
    mywad.playpal.pallets[3].colors[119].g.should eq 98
    mywad.playpal.pallets[5].colors[255].r.should eq 215
    mywad.playpal.pallets[6].colors[75].b.should eq 11
    mywad.playpal.pallets[13].colors[86].r.should eq 175
    mywad.playpal.pallets[13].colors[171].g.should eq 167
    mywad.playpal.pallets[13].colors[255].b.should eq 94
  end

  it "should properly set the colormap" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.colormap.tables[0].table[0].should eq 0
    mywad.colormap.tables[0].table[208].should eq 4
    mywad.colormap.tables[0].table[255].should eq 255
    mywad.colormap.tables[1].table[88].should eq 89
    mywad.colormap.tables[2].table[3].should eq 105
    mywad.colormap.tables[33].table[255].should eq 0
    mywad.colormap.tables[33].table[255].should eq 0
  end

  it "should properly set the textureX's" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.texmaps[0].numtextures.should eq 125
    mywad.texmaps[0].offsets[0].should eq 504
    mywad.texmaps[0].offsets[1].should eq 546
    mywad.texmaps[0].offsets[2].should eq 618
    mywad.texmaps[1].offsets[0].should eq 648
    mywad.texmaps[1].offsets[1].should eq 680
    mywad.texmaps[1].offsets[2].should eq 712
    mywad.texmaps[0].mtextures[0].name = "AASTINKY"
    mywad.texmaps[0].mtextures[0].width.should eq 24
    mywad.texmaps[0].mtextures[0].patches[1].originx.should eq 12
    mywad.texmaps[1].mtextures[0].name = "ASHWALL"
    mywad.texmaps[1].mtextures[0].height.should eq 128
    mywad.texmaps[1].mtextures[0].patches[0].originx.should eq 0
  end

  it "should properly set the EnDoom" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.endoom.characters[0].ascii_value.should eq 32
    mywad.endoom.characters[0].color.should eq 14
    mywad.endoom.characters[1].ascii_value.should eq 32
    mywad.endoom.characters[1].color.should eq 15
    mywad.endoom.characters[-1].ascii_value.should eq 32
    mywad.endoom.characters[-1].color.should eq 7
  end

  it "should properly set the Pnames" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.pnames.num_patches.should eq 350
    mywad.pnames.patches[0].should eq "WALL00_3"
    mywad.pnames.patches[111].should eq "WALL57_4"
    mywad.pnames.patches[219].should eq "PS18A0"
    mywad.pnames.patches[349].should eq "SW2_4"
  end

  it "should properly set the graphics" do
    mywad = WAD.read("./rsrc/DOOM.WAD")
  end
end
