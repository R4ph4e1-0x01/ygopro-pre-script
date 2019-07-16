--海晶乙女クリスタルハート

--Scripted by nekrozar
function c101010040.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101010040.immcon1)
	e1:SetValue(c101010040.efilter1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c101010040.immcon2)
	e2:SetTarget(c101010040.immtg2)
	e2:SetValue(c101010040.efilter2)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010040,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101010040.indcon)
	e3:SetCost(c101010040.indcost)
	e3:SetTarget(c101010040.indtg)
	e3:SetOperation(c101010040.indop)
	c:RegisterEffect(e3)
end
function c101010040.immcon1(e)
	return e:GetHandler():GetSequence()>4
end
function c101010040.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c101010040.immcon2(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler():GetBattleTarget()
end
function c101010040.immtg2(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c101010040.efilter2(e,te,c)
	return c~=te:GetOwner()
end
function c101010040.indcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if not at then return false end
	local c=e:GetHandler()
	if at==c then return true end
	local lg=c:GetLinkedGroup()
	return at and at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0x12b) and lg:IsContains(at)
end
function c101010040.costfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101010040.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010040.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101010040.costfilter,1,1,REASON_COST)
end
function c101010040.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttackTarget():CreateEffectRelation(e)
end
function c101010040.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	if at:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		at:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e3:SetOperation(c101010040.damop)
		e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e3,tp)
	end
end
function c101010040.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end