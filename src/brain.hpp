#pragma once

#include <godot_cpp/classes/resource.hpp>
#include <Eigen/Core>
#include "layer.hpp"

namespace godot {
	class Brain : public Resource {
		GDCLASS(Brain, Resource)

		private:
			Eigen::VectorXf inputs;
			std::vector<Layer> layers {};
			Eigen::VectorXf outputs;

			void mutate();

		protected:
			static void _bind_methods();

		public:
			Brain(int layersSizes[]);
			Brain(const std::vector<Layer>& layers) : layers(layers) { mutate(); }
			~Brain();

			void feedforward(const Eigen::VectorXf& inputs);
	};
}
