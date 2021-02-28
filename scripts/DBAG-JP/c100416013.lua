--溟界の呼び蛟

--scripted by Xylen5967
function c100416013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c100416013.target)
	e1:SetOperation(c100416013.operation)
	c:RegisterEffect(e1)
end
function c100416013.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100416013.cfilter(c)
	return c:IsSetCard(0x264) and c:IsType(TYPE_MONSTER)
end
function c100416013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
		local cg=Duel.GetMatchingGroup(c100416013.cfilter,tp,LOCATION_GRAVE,0,nil)
		local tg=Duel.GetMatchingGroup(c100416013.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return Duel.IsPlayerCanSpecialSummonMonster(tp,100416113,0,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK)
			or cg:GetClassCount(Card.GetCode)>=8 and tg:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c100416013.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local cg=Duel.GetMatchingGroup(c100416013.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100416013.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local res1=Duel.IsPlayerCanSpecialSummonMonster(tp,100416113,0,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK)
	local res2=cg:GetClassCount(Card.GetCode)>=2 and tg:GetClassCount(Card.GetCode)>=2
	if res2 and (not res1 or Duel.SelectYesNo(tp,aux.Stringid(100416013,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	elseif res1 then
		for i=1,2 do
			local token=Duel.CreateToken(tp,100416113)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
