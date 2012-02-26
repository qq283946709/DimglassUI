hooksecurefunc("AuctionFrame_LoadUI", function()
    if AuctionFrameBrowse_Update then
        hooksecurefunc("AuctionFrameBrowse_Update", function()
            local numBatchAuctions = GetNumAuctionItems("list")
            local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
            for i=1, NUM_BROWSE_TO_DISPLAY do
                local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
                if index <= numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page) then
                    local name, _, _, _, _, _, _, _, _, buyoutPrice, bidAmount =  GetAuctionItemInfo("list", offset + i)
                    local color = "yellow"
                    if name then
                        local itemName = _G["BrowseButton"..i.."Name"]
                        local buyoutMoney = _G["BrowseButton"..i.."BuyoutFrameMoney"]
						--价格大于10000时显示为红色
                        if (buyoutPrice/10000) >= 10000 then	color = "red" end
						--显示是否已被竞拍
                        if bidAmount > 0 then
                            if string.len(name) > 40 then
                                name = string.sub(name, 0, 36) .. "..."
                            end
                            name = "|cffffff00bid |r" .. name
                        end
                        itemName:SetText(name)
                        SetMoneyFrameColor(buyoutMoney:GetName(), color)
					end
                end
            end
        end)
    end
end)