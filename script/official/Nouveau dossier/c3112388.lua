--Elemental HERO Shining Neos
local s,id=GetID()
function s.initial_effect(c)
--fusion material
  c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,hspfilter)
    --Destroy 1 of opponent's cards, then apply appropriate effect, based on the card type
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(id,0))
  e6:SetCategory(CATEGORY_DESTROY)
  e6:SetType(EFFECT_TYPE_IGNITION)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e6:SetCondition(s.descon)
  e6:SetTarget(s.destg)
  e6:SetOperation(s.desop)
  c:RegisterEffect(e6)
  local e7=e6:Clone()
  e7:SetDescription(aux.Stringid(id,1))
  e7:SetType(EFFECT_TYPE_QUICK_O)
  e7:SetCode(EVENT_FREE_CHAIN)
  e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
  e7:SetCondition(s.setcon2)
  c:RegisterEffect(e7)
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
s.setcode={85507811}
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.hspfilter(c,tp,sc)
  return c:IsCode(85507811) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
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
function s.descon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    Duel.Destroy(tc,REASON_EFFECT)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    --Cannot attack this turn
    if tc:IsType(TYPE_MONSTER) then
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(3206)
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetRange(LOCATION_MZONE)
      e1:SetTargetRange(LOCATION_MZONE,0)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
      e1:SetValue(500)
      c:RegisterEffect(e1)
      --Can attack all monsters
       elseif tc:IsType(TYPE_SPELL) then
       local e1=Effect.CreateEffect(c)
       e1:SetDescription(3205)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_ATTACK_ALL)
       e1:SetValue(1)
       c:RegisterEffect(e1)
       --damage & recover
   else    
       local e1=Effect.CreateEffect(c)
       e1:SetDescription(aux.Stringid(id,1))
       e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
       e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
       e1:SetCode(EVENT_DAMAGE_STEP_END)
       e1:SetTarget(s.damtg)
       e1:SetOperation(s.damop)
       c:RegisterEffect(e1)
       end
        function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetAttackTarget()~=nil end
  local c=e:GetHandler()
  local d=Duel.GetAttackTarget()
  if d==c then d=Duel.GetAttacker() end
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetDefense())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,d:GetAttack())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
  local ex1,a1,b1,p1,d1=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
  local ex2,a2,b2,p2,d2=Duel.GetOperationInfo(0,CATEGORY_RECOVER)
  Duel.Damage(1-tp,d1,REASON_EFFECT,true)
  Duel.Recover(tp,d2,REASON_EFFECT,true)
  Duel.RDComplete()
end
    end
    end
    function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,42015635),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end