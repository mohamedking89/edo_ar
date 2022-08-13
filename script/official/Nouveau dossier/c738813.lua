--Elemental HERO Celestial Neos
local s,id=GetID()
function s.initial_effect(c)
  --fusion material
  c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,hspfilter) 
  --atkup
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(s.atkval)
  c:RegisterEffect(e1)
  --Cannot be destroyed by battle or card effects
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetCondition(s.incon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
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
  --damage reduce
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD)
  e6:SetCode(EFFECT_CHANGE_DAMAGE)
  e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e6:SetRange(LOCATION_MZONE)
  e6:SetTargetRange(1,0)
  e6:SetValue(s.damval)
  c:RegisterEffect(e6)
  local e7=e6:Clone()
  e7:SetCode(EFFECT_NO_EFFECT_DAMAGE)
end
s.setcode={11502550}
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.hspfilter(c,tp,sc)
  return c:IsCode(11502550) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
  end
function s.atkval(e,c)
  local lps=Duel.GetLP(c:GetControler())
  local lpo=Duel.GetLP(1-c:GetControler())
  if lps<=lpo then return 0
  else return lps-lpo end
end
function s.indesfil(c)
  return c:IsFaceup() and c:IsCode(42015635)
end
function s.incon(e)
  return Duel.IsExistingMatchingCard(s.indesfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
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
function s.damval(e,re,val,r,rp,rc)
  if r&REASON_EFFECT~=0 then return 0 end
  return val
end