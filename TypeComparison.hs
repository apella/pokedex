-- | provides methods to see what types of attacks are effective
-- against what and what defenses are good against what
module TypeComparison (weakDefenseAgainst, strongDefenseAgainst, against, getTypesAccordingTo, typeMap, DamageMult) where
import Pokemon
import Data.List (union)
import qualified Data.Map as M (Map, fromList, lookup, mapMaybeWithKey, elems) 

type DamageMult = Double

-- | What types have a weak defense against the given type?
weakDefenseAgainst :: Type -> [Type]
weakDefenseAgainst t = getTypesAccordingTo (\(a, d) v -> if (t == a) && (v > 1) then Just d else Nothing)

-- | What types have a strong defense against the given type?
strongDefenseAgainst :: Type -> [Type]
strongDefenseAgainst t = getTypesAccordingTo (\(a, d) v -> if (t == a) && (v < 1) then Just d else Nothing)


-- | Higher order function for getting info on types
getTypesAccordingTo :: ((Type, Type) -> Double -> Maybe Type) -> [Type]
getTypesAccordingTo fun = M.elems $ M.mapMaybeWithKey fun typeMap

-- | Return the effectiveness of @t1@ 'against' @t2@
against ::  Type -> Type -> Double
t1 `against` t2 = maybe 1 id $ M.lookup (t1, t2) typeMap

-- | What types will do poor against the given type?
weakOffenseAgainst :: Type -> [Type]
weakOffenseAgainst t = getTypesAccordingTo (\(a, d) v -> if (t == d) && (v < 1) then Just a else Nothing)

-- | What types will to well against the given type?
strongOffenseAgainst :: Type -> [Type]
strongOffenseAgainst t = getTypesAccordingTo (\(a, d) v -> if (t == d) && (v > 1) then Just a else Nothing)

describeDefender :: Pokemon -> [Type]
describeDefender =
  foldr union [] .  map strongDefenseAgainst . types

-- | A map containing the multipliers for attack types.
--   If it's not in the map, the multiplier is 1.
--   Structure: ((Attacker, Defender), multiplier)
typeMap :: M.Map (Type, Type) DamageMult
typeMap = M.fromList [((Normal, Rock), 0.5)
                   ,((Normal, Ghost), 0)
                   ,((Normal, Steel), 0.5)
                   ,((Fighting, Normal), 2)
                   ,((Fighting, Flying), 0.5)
                   ,((Fighting, Poison), 0.5)
                   ,((Fighting, Rock), 2)
                   ,((Fighting, Bug), 0.5)
                   ,((Fighting, Ghost), 0)
                   ,((Fighting, Steel), 2)
                   ,((Fighting, Psychic), 0.5)
                   ,((Fighting, Ice), 2)
                   ,((Fighting, Dark), 2)
                   ,((Flying, Fighting), 2)
                   ,((Flying, Rock), 0.5)
                   ,((Flying, Bug), 2)
                   ,((Flying, Steel), 0.5)
                   ,((Flying, Grass), 2)
                   ,((Flying, Electric), 0.5)
                   ,((Poison, Poison), 0.5)
                   ,((Poison, Ground), 0.5)
                   ,((Poison, Rock), 0.5)
                   ,((Poison, Ghost), 0.5)
                   ,((Poison, Steel), 0)
                   ,((Poison, Grass), 2)
                   ,((Ground, Flying), 0)
                   ,((Ground, Poison), 2)
                   ,((Ground, Rock), 2)
                   ,((Ground, Bug), 0.5)
                   ,((Ground, Steel), 2)
                   ,((Ground, Fire), 2)
                   ,((Ground, Grass), 0.5)
                   ,((Ground, Electric), 2)
                   ,((Rock, Fighting), 0.5)
                   ,((Rock, Flying), 2)
                   ,((Rock, Ground), 0.5)
                   ,((Rock, Bug), 2)
                   ,((Rock, Steel), 0.5)
                   ,((Rock, Fire), 2)
                   ,((Rock, Ice), 2)
                   ,((Bug, Fighting), 0.5)
                   ,((Bug, Flying), 0.5)
                   ,((Bug, Poison), 0.5)
                   ,((Bug, Ghost), 0.5)
                   ,((Bug, Steel), 0.5)
                   ,((Bug, Fire), 0.5)
                   ,((Bug, Grass), 2)
                   ,((Bug, Psychic), 2)
                   ,((Bug, Dark), 2)
                   ,((Ghost, Normal), 0)
                   ,((Ghost, Ghost), 2)
                   ,((Ghost, Steel), 0.5)
                   ,((Ghost, Psychic), 2)
                   ,((Ghost, Dark), 0.5)
                   ,((Steel, Rock), 2)
                   ,((Steel, Steel), 0.5)
                   ,((Steel, Fire), 0.5)
                   ,((Steel, Water), 0.5)
                   ,((Steel, Electric), 0.5)
                   ,((Steel, Ice), 2)
                   ,((Fire, Rock), 0.5)
                   ,((Fire, Bug), 2)
                   ,((Fire, Steel), 2)
                   ,((Fire, Fire), 0.5)
                   ,((Fire, Water), 0.5)
                   ,((Fire, Grass), 2)
                   ,((Fire, Ice), 2)
                   ,((Fire, Dragon), 0.5)
                   ,((Water, Ground), 2)
                   ,((Water, Rock), 2)
                   ,((Water, Fire), 2)
                   ,((Water, Water), 0.5)
                   ,((Water, Grass), 0.5)
                   ,((Water, Dragon), 0.5)
                   ,((Grass, Flying), 0.5)
                   ,((Grass, Poison), 0.5)
                   ,((Grass, Ground), 2)
                   ,((Grass, Rock), 2)
                   ,((Grass, Bug), 0.5)
                   ,((Grass, Steel), 0.5)
                   ,((Grass, Fire), 0.5)
                   ,((Grass, Water), 2)
                   ,((Grass, Grass), 0.5)
                   ,((Grass, Dragon), 0.5)
                   ,((Electric, Flying), 2)
                   ,((Electric, Ground), 0)
                   ,((Electric, Water), 2)
                   ,((Electric, Grass), 0.5)
                   ,((Electric, Electric), 0.5)
                   ,((Electric, Dragon), 0.5)
                   ,((Psychic, Fighting), 2)
                   ,((Psychic, Poison), 2)
                   ,((Psychic, Steel), 0.5)
                   ,((Psychic, Psychic), 0.5)
                   ,((Psychic, Dark), 0)
                   ,((Ice, Flying), 2)
                   ,((Ice, Ground), 2)
                   ,((Ice, Steel), 0.5)
                   ,((Ice, Fire), 0.5)
                   ,((Ice, Water), 0.5)
                   ,((Ice, Grass), 2)
                   ,((Ice, Ice), 0.5)
                   ,((Ice, Dragon), 2)
                   ,((Dragon, Steel), 0.5)
                   ,((Dragon, Dragon), 2)
                   ,((Dark, Fighting), 0.5)
                   ,((Dark, Ghost), 2)
                   ,((Dark, Steel), 0.5)
                   ,((Dark, Psychic), 2)
                   ,((Dark, Dark), 0.5)]

