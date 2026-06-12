#include <godot_cpp/core/class_db.hpp>
#include "brain.hpp"

using namespace godot;

void Brain::_bind_methods() {
	ClassDB::bind_method(D_METHOD("first_initialize", "layersSizes"), &Brain::first_initialize);
	ClassDB::bind_method(D_METHOD("mutate"), &Brain::mutate);
	ClassDB::bind_method(D_METHOD("feedforward", "inputs"), &Brain::feedforward);
}

void Brain::first_initialize(const PackedInt32Array& layersSizes) {
	this->layersSizes = layersSizes;
	for (int i = 1; i < layersSizes.size(); i++) {
		Ref<Layer> new_layer;
		new_layer.instantiate();
		new_layer->initialize(layersSizes[i], layersSizes[i-1], ActivationFunction::Sigmoid);
		layers.append(new_layer);
	}
}

void Brain::mutate() {
	for (int i = 0; i < layers.size(); i++) {
		Ref<Layer> layer = layers[i];
		if (layer.is_valid()) {
			layer->mutate();
        }
	}
}

PackedFloat32Array Brain::feedforward(const PackedFloat32Array& inputs) {
	Eigen::VectorXf outputs = godotToEigen(inputs);
	for (int i = 0; i < layers.size(); i++) {
		Ref<Layer> layer = layers[i];
		if (layer.is_valid()) {
			outputs = layer->feedforward(outputs);
		}
	}
	return eigenToGodot(outputs);
}

Eigen::VectorXf Brain::godotToEigen(const PackedFloat32Array& inputsGodot) {
	Eigen::VectorXf inputsEigen(layersSizes[0], 1);
	for (int i = 0; i < inputsGodot.size(); i++) {
		inputsEigen(i) = inputsGodot[i];
	}
	return inputsEigen;
}

PackedFloat32Array Brain::eigenToGodot(const Eigen::VectorXf& outputsEigen) {
	PackedFloat32Array outputsGodot;
	for (int i = 0; i < outputsEigen.rows(); i++) {
		outputsGodot.append(outputsEigen(i));
	}
	return outputsGodot;
}
