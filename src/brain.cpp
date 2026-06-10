#include <godot_cpp/core/class_db.hpp>
#include "brain.hpp"

using namespace godot;

void Brain::_bind_methods() {

}

Brain::Brain(int layersSizes[]) {
	for (int i = 1; i < sizeof(layersSizes) / sizeof(layersSizes[0]); i++) {
		layers.emplace_back(layersSizes[i], layersSizes[i-1], ActivationFunction::Sigmoid);
	}
}

Brain::~Brain() {

}

void Brain::mutate() {
	for (Layer& layer : layers) {
		layer.mutate();
	}
}

void Brain::feedforward(const Eigen::VectorXf& inputs) {
	outputs = inputs;
	for (Layer& layer : layers) {
		outputs = layer.feedforward(outputs);
	}
}
