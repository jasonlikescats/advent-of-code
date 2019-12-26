require "curses"

module Day13
    class RendererBase
        def initialize(render_char)
            @render_char = render_char
        end

        def refresh(cell_data)
            start_refresh
            cell_data.each do |row_num, row|
                str = ""
                row.each do |cell, value|
                    if value
                        str += @render_char.call(value)
                    end
                end
                render_line(str)
            end
        end
    end

    class CursesRenderer < RendererBase
        def initialize(row_count, col_count, render_char)
            super(render_char)

            Curses.init_screen
            Curses.curs_set 0 # invisible cursor
            Curses.noecho # don't echo keys entered

            @window = Curses::Window.new(row_count, col_count, 0, 0)
        end

        def teardown
            Curses.close_screen
        end

        protected 

        def start_refresh
            @window.setpos(0, 0)
        end

        def render_line(str)
            @window << str
            @window.refresh
        end
    end

    class ConsoleRenderer < RendererBase
        def initialize(render_char)
            super(render_char)
            @frame = 0
        end

        def teardown
        end

        protected

        def start_refresh
            puts "\nFRAME #{@frame}:"
            @frame += 1
        end

        def render_line(str)
            puts str
        end
    end
end
