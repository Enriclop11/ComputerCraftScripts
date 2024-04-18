-- Exported table

local M = {}

function M.runThreads(functions)
    if(#functions == 1) then
        functions[1]()
    else
        local splitFunctions = {}
        -- functions withouth the first one
        for i = 2, #functions do
            table.insert(splitFunctions, functions[i])
        end
        parallel.waitForAll(
            functions[1],
            function()
                M.runThreads(splitFunctions)
            end
        )
    end
end

return M