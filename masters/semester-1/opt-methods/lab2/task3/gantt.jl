using Crayons

function gantt_chart(T, durations, end_time)
    function print_white(s)
      print(Crayon(background=:white), s)
    end

    function print_normal()
      print(Crayon(background=:default), "")
    end

    function print_color(s, color_index)
      cryaons = [Crayon(background=:yellow) Crayon(background=:blue) Crayon(background=:green) Crayon(background=(255, 165, 0))]
      print(cryaons[color_index], s)
    end

    function get_symbols(times)
      result = []

      for i in 1:length(times)
        push!(result, (Int64(times[i]), i))
      end

      return sort(result, by = first)
    end

    (n, m) = size(T)

    start_times = zeros(Float64, n, m)
    for i in 1:n, j in 1:m
      start_times[i, j] = value(T[i, j])
    end

    for processor_nr in 1:n
        printed_symbols = 0
        start_times_with_symbols = get_symbols(start_times[processor_nr, :])

        for _ in 1:start_times_with_symbols[1][1]
            printed_symbols+=1
            print_white("   ")
        end

        for i in 1:size(start_times_with_symbols)[1]
            while printed_symbols < start_times_with_symbols[i][1] + durations[processor_nr, start_times_with_symbols[i][2]]
                printed_symbols+=1
                print_color(" $(start_times_with_symbols[i][2]) ", start_times_with_symbols[i][2])
            end

            while i < size(start_times_with_symbols)[1] && printed_symbols < start_times_with_symbols[i + 1][1]
                printed_symbols+=1
                print_white("   ")
            end
        end

        while printed_symbols < end_time
            printed_symbols+=1
            print_white("   ")
        end

        print_normal()
        println()
    end
end