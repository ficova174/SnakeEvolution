#include "brain.hpp"
#include <godot_cpp/core/class_db.hpp>
#include <Eigen/LU>

using namespace godot;

void Brain::_bind_methods() {
}

Brain::Brain() {
	// Initialize any variables here.
	time_passed = 0.0;
}

Brain::~Brain() {
	// Add your cleanup here.
}
