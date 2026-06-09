#pragma once

#include <godot_cpp/classes/resource.hpp>

namespace godot {

class Brain : public Resource {
	GDCLASS(Brain, Resource)

private:
	double time_passed;

protected:
	static void _bind_methods();

public:
	Brain();
	~Brain();
};

} // namespace godot
