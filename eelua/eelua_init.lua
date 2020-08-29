local package = require"package"
package.path = package.path .. [[;.\eelua\?.lua]]

local print_r = require"print_r"

print_r(package)
