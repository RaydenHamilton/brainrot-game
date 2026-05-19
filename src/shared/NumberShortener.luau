local format = {}
local suffixes = {
	{ 1e63, "Vg" },
	{ 1e60, "Novd" },
	{ 1e57, "Octd" },
	{ 1e54, "Spd" },
	{ 1e51, "Sxd" },
	{ 1e48, "Qad" },
	{ 1e45, "Qid" },
	{ 1e42, "Td" },
	{ 1e39, "Dd" },
	{ 1e36, "Ud" },
	{ 1e33, "Dc" },
	{ 1e30, "No" },
	{ 1e27, "Oc" },
	{ 1e24, "Sp" },
	{ 1e21, "Sx" },
	{ 1e18, "Qi" },
	{ 1e15, "Qa" },
	{ 1e12, "T" },
	{ 1e9, "B" },
	{ 1e6, "M" },
	{ 1e3, "K" },
}

function format.Number(number)
	for _, suffix in ipairs(suffixes) do
		local value = suffix[1]
		local letter = suffix[2]

		if number >= value then
			local shortened = number / value
			return string.format("%.1f%s", shortened, letter)
		end
	end

	return tostring(number)
end
return format
