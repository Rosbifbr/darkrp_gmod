if CLIENT then return end

resource.AddSingleFile("materials/entities/zmlab2_dropoff.png")
resource.AddSingleFile("materials/entities/zmlab2_equipment.png")
resource.AddSingleFile("materials/entities/zmlab2_item_autobreaker.png")
resource.AddSingleFile("materials/entities/zmlab2_item_crate.png")
resource.AddSingleFile("materials/entities/zmlab2_item_frezzertray.png")
resource.AddSingleFile("materials/entities/zmlab2_item_meth.png")
resource.AddSingleFile("materials/entities/zmlab2_item_palette.png")
resource.AddSingleFile("materials/entities/zmlab2_machine_filler.png")
resource.AddSingleFile("materials/entities/zmlab2_machine_filter.png")
resource.AddSingleFile("materials/entities/zmlab2_machine_frezzer.png")
resource.AddSingleFile("materials/entities/zmlab2_machine_furnace.png")
resource.AddSingleFile("materials/entities/zmlab2_machine_mixer.png")
resource.AddSingleFile("materials/entities/zmlab2_machine_ventilation.png")
resource.AddSingleFile("materials/entities/zmlab2_npc.png")
resource.AddSingleFile("materials/entities/zmlab2_storage.png")
resource.AddSingleFile("materials/entities/zmlab2_table.png")
resource.AddSingleFile("materials/entities/zmlab2_tent.png")

if zmlab2.config.FastDl then
	zmlab2 = zmlab2 or {}
	zmlab2.Download = zmlab2.Download or {}

	function zmlab2.Download.AddDir(path)
		local files, folders = file.Find(path .. "/*", "GAME")

		for k, v in pairs(files) do
			resource.AddFile(path .. "/" .. v)
		end

		for k, v in pairs(folders) do
			zmlab2.Download.AddDir(path .. "/" .. v)
		end
	end

	zmlab2.Download.AddDir("sound/zmlab2/")
	zmlab2.Download.AddDir("models/zerochain/props_methlab/")
	zmlab2.Download.AddDir("materials/zerochain/props_methlab/")
	zmlab2.Download.AddDir("materials/zerochain/zmlab2/")

	resource.AddSingleFile("particles/zmlab2_fx.pcf")

	resource.AddSingleFile("resource/fonts/nexa-bold.ttf")
	resource.AddSingleFile("resource/fonts/nexa-light-webfont.ttf")

else
	resource.AddWorkshop( "2486834214" ) // Zeros Methlab 2 Contentpack
	//https://steamcommunity.com/sharedfiles/filedetails/?id=2486834214
end
