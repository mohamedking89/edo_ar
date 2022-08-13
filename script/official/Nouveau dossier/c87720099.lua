--Elemental HERO Abyssal Neos
local s,id=GetID()
function s.initial_effect(c)
--fusion material
  c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,hspfilter)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCost(s.cost)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
    local e2=e1:Clone()
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
  e2:SetCondition(s.setcon2)
  c:RegisterEffect(e2)
  --cannot remove
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_CANNOT_REMOVE)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(0,1)
  e3:SetTarget(s.rmlimit)
  c:RegisterEffect(e3)
  --spsummon condition
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e4:SetCode(EFFECT_SPSUMMON_CONDITION)
  e4:SetValue(aux.fuslimit)
  c:RegisterEffect(e4)
  --spsummon
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e5:SetCode(EFFECT_SPSUMMON_PROC)
  e5:SetRange(LOCATION_EXTRA)
  e5:SetCondition(s.hspcon)
  e5:SetTarget(s.hsptg)
  e5:SetOperation(s.hspop)
  c:RegisterEffect(e5)
end
s.setcode={55171412}
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.hspfilter(c,tp,sc)
  return c:IsCode(55171412) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
  end
function s.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.CheckReleaseGroup(tp,s.hspfilter,1,false,1,true,c,tp,nil,false,nil,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
  local g=Duel.SelectReleaseGroup(tp,s.hspfilter,1,1,false,true,true,c,nil,nil,false,nil,tp,c)
  if g then
    g:KeepAlive()
    e:SetLabelObject(g)
  return true
  end
  return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  local g=e:GetLabelObject()
  if not g then return end
  Duel.Release(g,REASON_COST)
  g:DeleteGroup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if #g>0 then
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
    local tg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
    local tc=tg:GetFirst()
    if tc then
      local atk=tc:GetAttack()
      if tc:IsAttackAbove(0) and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsAttackAbove,atk),tp,LOCATION_MZONE,0,1,nil) then
        Duel.Destroy(tc,REASON_EFFECT)
        Duel.Damage(1-tp,1000,REASON_EFFECT)
      else
        Duel.Damage(tp,1000,REASON_EFFECT)
      end
    end
    Duel.ShuffleHand(1-tp)
  end
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,42015635),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.rmlimit(e,c,p)
  return c:IsLocation(LOCATION_GRAVE)
end