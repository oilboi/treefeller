--destroy all trees
tree_fall = function(pos)

  local air = minetest.get_content_id("air")

	local min = {x=pos.x-1,y=pos.y-1,z=pos.z-1}
	local max = {x=pos.x+1,y=pos.y+1,z=pos.z+1}
	local vm = minetest.get_voxel_manip()
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
  local content_id = minetest.get_name_from_content_id

	for x=-1, 1 do
	for y=-1, 1 do
	for z=-1, 1 do
			local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
			local n = content_id(data[p_pos])
      if minetest.get_item_group(n, "tree") ~= 0 then
				data[p_pos] = air
        --call to repeat in loop until finished
        minetest.add_item({x=pos.x+x, y=pos.y+y, z=pos.z+z},n)
        minetest.after(0,function(pos,x,y,z)
          tree_fall({x=pos.x+x, y=pos.y+y, z=pos.z+z})
        end,pos,x,y,z)
			end

	end
	end
	end
	vm:set_data(data)
	vm:write_to_map()
end

minetest.register_on_dignode(function(pos, oldnode, digger)
  local node = oldnode.name

  if minetest.get_item_group(node, "tree") > 0 then
    local wield = digger:get_wielded_item():to_string()--minetest.registered_items
    if string.match(wield, ":axe_") then
      tree_fall(pos)
    end
  end
end)
