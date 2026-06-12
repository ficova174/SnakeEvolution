#include <godot_cpp/core/class_db.hpp>
#include "layer.hpp"

using namespace godot;

void Layer::_bind_methods() {

}

void Layer::initialize(int currentLayerSize, int previousLayerSize, ActivationFunction activation) {
    weights = Eigen::MatrixXf::Random(currentLayerSize, previousLayerSize) * initialRange;
    bias = Eigen::VectorXf::Random(currentLayerSize) * initialRange;
	this->activation = activation;
}

void Layer::mutate() {
	Eigen::MatrixXf mutationWeights = Eigen::MatrixXf::Random(weights.rows(), weights.cols()) * mutationRate;
	Eigen::MatrixXf mutationBias = Eigen::VectorXf::Random(bias.rows()) * mutationRate;
	weights += mutationWeights;
	bias += mutationBias;
}

Eigen::VectorXf Layer::feedforward(Eigen::VectorXf inputs) {
	Eigen::VectorXf z{ weights * inputs + bias };
	switch (activation) {
		case ActivationFunction::Sigmoid:
			return (1.0f / (1.0f + (-z.array()).exp())).matrix();
		case ActivationFunction::Tanh:
			return z.array().tanh().matrix();
		case ActivationFunction::ReLU:
			return z.array().max(0.0f).matrix();
	}
}
