#pragma once

#include <godot_cpp/classes/resource.hpp>
#include <Eigen/Core>

namespace godot {
    enum class ActivationFunction {
        Sigmoid,
        Tanh,
        ReLU
    };

    class Layer : public Resource {
        GDCLASS(Layer, Resource)

        private:
            Eigen::MatrixXf weights;
            Eigen::VectorXf bias;

            ActivationFunction activation;

        protected:
            static void _bind_methods();

        public:
            Layer(int layerSize, int previousLayerSize, ActivationFunction activation);
            ~Layer();

            Eigen::MatrixXf getWeights() const { return weights; }
            Eigen::VectorXf getBias() const { return bias; }

            void mutate();

            Eigen::VectorXf feedforward(Eigen::VectorXf inputs);
    };
}
