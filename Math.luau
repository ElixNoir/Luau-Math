--- Author: COMT

--[[

	Math - A module for math functions.

]]

--!native
--!optimize 2
--!strict


-- -- State

local Module = {}


-- -- Helpers

local math_abs = math.abs
local math_e = math.e
local math_max = math.max
local math_min = math.min
local math_pi = math.pi
local math_random = math.random
local math_sqrt = math.sqrt

local table_create = table.create
local table_unpack = table.unpack

local Factorial_Cache: {number} = {1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 355687428096000, 6402373705728000}
local Fibonacci_Cache: {number} = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610}
local Pies = 2 * math_pi
local Sqrt5 = math_sqrt(5)
local Phi = (1 + Sqrt5) / 2


-- -- Functions

-- -- -- Algebra

--[[
	Simplify a string representation of a mathematical function.
]]
function Module.simplify(func: string): string
	-- This will require a parser.  I don't have the time right now.
	return "something"
end


-- -- -- Calculus

--[[
	With caching, get the nth factorial.
	
	This assumes that the number is greater than 0 and less than 19.  0! == 1, negative numbers are not acceptable.
	
	Because these numbers quickly pass the limit of the number type, which is a double-precision floating-point value accurate up to only 53 bits (for integers), there is no reason to need to do anything special.
	
	returns: factorial
]]
function Module.factorial(n: number): number?
	return Factorial_Cache[n]
end

--[[
	Without caching, get the nth fibonacci number.
	
	This assumes that the number is greater than 0.  A sequence does not have negative iterations.
	
	returns: fibonacciNumber
]]
function Module.fibonacci(n: number): number
	return (Phi ^ n / Sqrt5 + 0.5) // 1
end

--[[
	With caching, get the nth fibonacci number.
	
	This assumes that the number is greater than 0.  A sequence does not have negative iterations.
	
	returns: fibonacciNumber
]]
function Module.fibonacci_Cached(n: number): number
	local length = #Fibonacci_Cache
	local value = Fibonacci_Cache[length]
	for index = length + 1, n do
		value += Fibonacci_Cache[index - 2] + Fibonacci_Cache[index - 3]
	end

	return value
end

--[[
	Without caching, get an approximation of the nth factorial.  This assumes that the number is greater than 0.  (0! == 1, negative numbers are not acceptable)
	
	returns: approximateFactorial
]]
function Module.stirlingApproximate(n: number): number
	return math_sqrt(Pies * n) * (n / math_e) ^ n
end


-- -- -- Geometry

--[[
	Get the area of a circle.

	returns: The area of the circle.
]]
function Module.circle_Area(radius: number): number
	return math_pi * radius * radius
end

function Module.circle_Perimeter(radius: number): number
	return Pies * radius
end Module.circle_Circumference = Module.circle_Perimeter

--[[
	Get the area of a polygon given by a list of points as (x1, y1, x2, y2, xn, yn).

	This assumes that the list has more than 1 point.

	returns: The area of the polygon.
]]
function Module.polygon_Area(points: {number}): number
	local length = #points

	local sum = 0
	local pointCount = length // 2

	for index = 1, pointCount, 2 do
		local j = (index % pointCount)
		sum += (points[index] * points[index + 1] - points[j] * points[j + 1])
	end

	return math_abs(sum) / 2
end

--[[
	Get the area of a rectangle.

	returns: The area of the rectangle.
]]
function Module.rectangle_Area(width: number, length: number): number
	return width * length
end

function Module.rectangle_Perimeter(width: number, length: number): number
	return 2 * width + 2 * length
end

--[[
	Get the area of a square.

	returns: The area of the square.
]]
function Module.square_Area(width: number): number
	return width * width
end

function Module.square_Perimeter(width: number): number
	return 4 * width
end

--[[
	Get the area of a triangle.

	returns: The area of the triangle.
]]
function Module.triangle_Area(x1: number, x2: number, x3: number, y1: number, y2: number, y3: number): number
	return math_abs((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) / 2
end

--[[
	Get the area of a triangle given the length of its sides.

	returns: The area of the triangle.
]]
local function triangle_Area_FromSideLengths(a: number, b: number, c: number): number
	local s = (a + b + c) / 2
	return math_sqrt(s * (s - a) * (s - b) * (s - c))
end

function Module.triangle_Perimeter(width: number): number
	return 0
end

--[[
	Get the signed area of a triangle.

	returns: The signed area of the triangle.
]]
function Module.triangle_SignedArea(x1: number, x2: number, x3: number, y1: number, y2: number, y3: number): number
	return (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1) / 2
end


-- -- -- Statistics

--[[
	Get the mean of a list of numbers.
	
	This assumes that the list is not empty.  The mean of an empty list is indeterminate.
	
	returns: mean
]]
function Module.mean(numbers: {number}): number
	local sum = 0
	for _, value in numbers do
		sum += value
	end
	
	return sum / #numbers
end

--[[
	Get the kth value of a range of numbers.
	
	This assumes that the list is not empty.  The kth value of an empty range is undefined.
	
	returns: median
]]
local function quickSelect(array: {number}, left: number, right: number, k: number): number
	while true do
		if left == right then
			return array[left]
		end

		local pivotIndex = math_random(left, right)
		local pivotValue = array[pivotIndex]
		
		array[pivotIndex], array[right] = array[right], array[pivotIndex]
		pivotIndex = left
		for i = left, right - 1 do
			if array[i] < pivotValue then
				array[i], array[pivotIndex] = array[pivotIndex], array[i]
				pivotIndex += 1
			end
		end
		array[pivotIndex], array[right] = array[right], array[pivotIndex]
		
		if k == pivotIndex then
			return array[k]
		elseif k < pivotIndex then
			right = pivotIndex - 1
		else
			left = pivotIndex + 1
		end
	end
end Module.quickSelect = quickSelect

--[[
	Get the median of a list of numbers.
	
	This assumes that the list is not empty.  The median of an empty list is undefined.
	
	returns: median
]]
function Module.median(array: {number}): number
	local length = #array
	return quickSelect(array, 1, length, (length + 1) // 2)
end

--[[
	Get the mode of a list of numbers.
	
	This assumes that the list is not empty.
	
	returns: mode
]]
function Module.mode(array: {number}): number
	local minimum = math_min(table_unpack(array))
	local amount = math_max(table_unpack(array)) - minimum
	minimum += 1
	
	local maximumCount = 0
	local mode = 0
	local countingArray = table_create(amount, 0) -- A hashmap or binary tree of some sort may work to reduce used memory, but at the cost of some speed.
	for _, value in array do
		local count = countingArray[value - minimum] + 1
		countingArray[value - minimum] = count
		if count > maximumCount then
			maximumCount = count
			mode = value
		end
	end
	
	return mode
end

--[[
	Get the variance of a list of numbers.
	
	This assumes that the list has more than 1 element.  The sqdiff of a list otherwise is 0 at 1 element, or undefined.
	
	If the list is a sample, multiply the result by the length of the array and then divide by one less than the length of the array.

	returns: sqdiff
]]
local function variance(array: {number}): number
	local length = #array

	local sum = 0
	for i = 1, length do
		sum = sum + array[i]
	end

	local mean = sum / length

	local sq_diff = 0
	for index = 1, length do
		local d = array[index] - mean
		sq_diff = sq_diff + d * d
	end

	return sq_diff / length
end Module.variance = variance

--[[
	The Welford method for calculating the variance of a list of numbers.
	
	This assumes that the list is not a sample and has more than 1 element.  The variance of a list otherwise is 0 at 1 element, or undefined.
	
	If the list is a sample, multiply the result by the length of the array and then divide by one less than the length of the array.

	returns: variance
]]
local function variance_Welford(array: {number}): number
	local n = 0
	local mean = 0
	local M2 = 0

	for i = 1, #array do
		n = n + 1
		local x = array[i]
		local delta = x - mean
		mean = mean + delta / n
		local delta2 = x - mean
		M2 = M2 + delta * delta2
	end

	return M2 / n
end Module.variance_Welford = variance_Welford

--[[
	The Welford method for calculating the standard deviation of a list of numbers.
	
	This assumes that the list has more than 1 element.  The standard deviation of a list otherwise is 0 at 1 element, or undefined.
	
	If the list is a sample, multiply the result by itself, multiply that by the length of the array, divide by one less than the length of the array, and then take the square root of that.

	returns: variance
]]
local function standardDeviation_Welford(array: {number}): number
	return math_sqrt(variance_Welford(array))
end Module.standardDeviation_Welford = standardDeviation_Welford

--[[
	Get the standard deviation of a list of numbers.

	This assumes that the list is not a sample and has more than 1 element.  The standard deviation of a list otherwise is 0 at 1 element, or undefined.
	
	If the list is a sample, multiply the result by itself, multiply that by the length of the array, divide by one less than the length of the array, and then take the square root of that.
	
	returns: standardDeviation
]]
function Module.standardDeviation(array: {number}): number
	return math_sqrt(variance(array))
end

--[[
	Get the sum of a list of numbers.

	returns: sum
]]
function Module.sum(array: {number}): number
	local sum = 0
	for _, value in array do
		sum += value
	end

	return sum
end


-- -- -- Vectors

--[[
	returns: crossProduct
]]
function Module.crossProduct(dx1: number, dy1: number, dx2: number, dy2: number): number
	return dx1 * dy2 - dx2 * dy1
end

--[[
	returns: dotProduct
]]
function Module.dotProduct(dx1: number, dy1: number, dx2: number, dy2: number): number
	return dx1 * dx2 + dy1 * dy2
end

--[[
	returns: intersected
]]
function Module.linesIntersect(ax1: number, ay1: number, ax2: number, ay2: number, bx1: number, by1: number, bx2: number, by2: number): boolean
	return ((by2 - by1) * (ax2 - ax1)) - ((bx2 - bx1) * (ay2 - ay1)) ~= 0
end

--[[
	returns: intersected, x, y
]]
function Module.linesIntersectionPoint(ax1: number, ay1: number, ax2: number, ay2: number, bx1: number, by1: number, bx2: number, by2: number): (boolean, number, number)
	local denominator = ((by2 - by1) * (ax2 - ax1)) - ((bx2 - bx1) * (ay2 - ay1))
	if denominator == 0 then
		return false, 0, 0
	end

	local ua = ((bx2 - bx1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / denominator
	local ub = ((ax2 - ax1) * (ay1 - by1) - (ay2 - ay1) * (ax1 - bx1)) / denominator
	return true, ax1 + ua * (ax2 - ax1), ay1 + ua * (ay2 - ay1)
end

--[[
	returns: intersected, x, y
]]
function Module.lineSegmentsIntersectionPoint(ax1: number, ay1: number, ax2: number, ay2: number, bx1: number, by1: number, bx2: number, by2: number): (boolean, number, number)
	local denominator = ((by2 - by1) * (ax2 - ax1)) - ((bx2 - bx1) * (ay2 - ay1))
	if denominator == 0 then
		return false, 0, 0
	end

	local ua = ((bx2 - bx1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / denominator
	local ub = ((ax2 - ax1) * (ay1 - by1) - (ay2 - ay1) * (ax1 - bx1)) / denominator
	if ua < 0 or ua > 1 or ub < 0 or ub > 1 then 
		return false, 0, 0
	end

	return true, ax1 + ua * (ax2 - ax1), ay1 + ua * (ay2 - ay1)
end


-- -- End

return Module
