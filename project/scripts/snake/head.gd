class_name Head
extends CharacterBody2D


var genome: Genome
var speed: float


func initialize(genome_init: Genome):
	genome = genome_init
	speed = genome.min_speed
