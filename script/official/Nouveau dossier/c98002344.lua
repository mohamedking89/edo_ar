--Elemental HERO Void Neos
local s,id=GetID()
function s.initial_effect(c)
--fusion material
  c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,hspfilter)
  --negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DISABLE)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetTarget(s.distg)
  e1:SetOperation(s.disop)
  c:RegisterEffect(e1)
    local e2=e1:Clone()
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
  e2:SetCondition(s.setcon2)
  c:RegisterEffect(e2)
  --copy
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,2))
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(s.copycost)
  e3:SetTarget(s.copytg)
  e3:SetOperation(s.copyop)
  c:RegisterEffect(e3)
      local e6=e3:Clone()
  e6:SetDescription(aux.Stringid(id,3))
  e6:SetType(EFFECT_TYPE_QUICK_O)
  e6:SetCode(EVENT_FREE_CHAIN)
  e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
  e6:SetCondition(s.fsetcon2)
  c:RegisterEffect(e6)
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
s.setcode={28677304}
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.hspfilter(c,tp,sc)
  return c:IsCode(28677304) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
  end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsTurnPlayer(1-tp)
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
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  local c=e:GetHandler()
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
  end
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,42015635),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 end
  e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.copyfilter(c)
  return c:IsFaceup() 
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.copyfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(s.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,s.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
    local code=tc:GetOriginalCodeRule()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(code)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    if not tc:IsType(TYPE_TRAPMONSTER) then
      c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
    end
  end
end
function s.fsetcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,42015635),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end