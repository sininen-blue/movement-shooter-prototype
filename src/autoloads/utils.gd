extends Node

func exp_decay(start: Variant, target: Variant, weight: float, delta: float) -> Variant:
	return target + (start - target) * exp(-weight * delta)
