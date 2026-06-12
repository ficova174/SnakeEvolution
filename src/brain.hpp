#pragma once

#include <godot_cpp/classes/resource.hpp>
#include <Eigen/Core>
#include "layer.hpp"

namespace godot {
	class Brain : public Resource {
		GDCLASS(Brain, Resource)

		private:
			PackedInt32Array layersSizes{};
			TypedArray<Layer> layers{};

		protected:
			static void _bind_methods();

		public:
			Brain() {}
			~Brain() {}

			void first_initialize(const PackedInt32Array& layersSizes);

			void mutate();

			PackedFloat32Array feedforward(const PackedFloat32Array& inputs);

			Eigen::VectorXf godotToEigen(const PackedFloat32Array& valuesGodot);
			PackedFloat32Array eigenToGodot(const Eigen::VectorXf& valuesEigen);
	};
}
