local format = {}
local suffixes = {
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
