--Elemental HERO Colossal Neos
local s,id=GetID()
function s.initial_effect(c)
--fusion material
  c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,hspfilter)
 --tohand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,1))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(s.thtg)
  e1:SetOperation(s.thop)
  c:RegisterEffect(e1)
    local e2=e1:Clone()
  e2:SetDescription(aux.Stringid(id,2))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
  e2:SetCondition(s.setcon2)
  c:RegisterEffect(e2)
  --remove
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCategory(CATEGORY_REMOVE)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
  e3:SetCountLimit(1)
  e3:SetCondition(s.rmcon)
  e3:SetTarget(s.rmtg)
  e3:SetOperation(s.rmop)
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
    --cannot be target
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE)
  e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e7:SetRange(LOCATION_MZONE)
  e7:SetValue(aux.tgoval)
  c:RegisterEffect(e7)
end
s.setcode={48996569}
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.hspfilter(c,tp,sc)
  return c:IsCode(48996569) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
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
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_FIELD) and chkc:IsControler(1-tp) and s.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_FIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_FIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,42015635),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemove()
    and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
  g:AddCard(e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
  if #g==0 or not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
  local rs=g:RandomSelect(1-tp,1)
  local rg=Group.FromCards(c,rs:GetFirst())
  if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
    local fid=c:GetFieldID()
    local og=Duel.GetOperatedGroup()
    local oc=og:GetFirst()
    for oc in aux.Next(og) do
      if oc~=c or not c:IsStatus(STATUS_COPYING_EFFECT) then
        if oc:IsControler(tp) then
          oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
        else
          oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,1,fid)
        end
      end
    end
    og:KeepAlive()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetLabel(fid)
    e1:SetLabelObject(og)
    e1:SetCondition(s.retcon)
    e1:SetOperation(s.retop)
    e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    Duel.RegisterEffect(e1,tp)
  end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()~=tp
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
  if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
  local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
  if #sg>0 then
    Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
  end
end
function s.retfilter(c,fid)
  return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetTurnPlayer()~=tp then return false end
  local g=e:GetLabelObject()
  if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
    g:DeleteGroup()
    e:Reset()
    return false
  else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  local sg=g:Filter(s.retfilter,nil,e:GetLabel())
  g:DeleteGroup()
  local tc=sg:GetFirst()
  for tc in aux.Next(sg) do
    if tc==e:GetHandler() then
      Duel.ReturnToField(tc)
    else
      Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
    end
  end
end