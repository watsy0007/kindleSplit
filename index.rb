require 'find'

class BookMark
  def initialize()
    @lines = Array.new
  end

  def push(line)
    @lines.push(line)
  end

  def to_s
    for line in @lines
      puts line
    end
  end

  def parse
    if @lines.length == 4
      m = @lines[0].match(/(.*?) \((.*?)\)/)
      @bookName , @author = m.captures

      if @lines[1] =~ /标注/
        m = @lines[1].match(/- 您在位置 #(\d+)-(\d+)的(.*?) \| 添加于 (.*?)星期(.*?) (.*)/)

        @start ,b,c,d,e,f = m.captures

        # puts "从#{a}到#{b}行 #{c},#{d},#{e},#{f}"
      else
        m = @lines[1].match(/- 您在位置 #(\d+) 的(.*?) \| 添加于 (.*?)星期(.*?) (.*)/)
        a,b,c,d,e = m.captures
        # puts "第#{a}行的#{b} #{c},#{d},#{e}"
      end
      @markInfo = @lines[3]
      # puts @lines[1]
      # puts @lines[3]
    end
  end

  def bookName
    @bookName
  end

  def author
    @author
  end

  def markInfo
    @markInfo
  end

  def start
    @start
  end
end

Dir.foreach('/Volumes/') do |path|
  if path == 'Kindle'
    File.open('/Volumes/Kindle/documents/My Clippings.txt',"r+") do |f|
      books = Hash.new
      bookMark = BookMark.new
      while line = f.gets
        if line == "==========\r\n"
          bookMark.parse
          if books.has_key?(bookMark.bookName)
            books[bookMark.bookName].push(bookMark)
          else
            marks = Array.new
            marks.push(bookMark)
            books[bookMark.bookName] = marks
          end
          bookMark = BookMark.new

        else
          bookMark.push(line)
        end
      end

      books.each do |k, v|
        puts "#{k}"
        v.each { |book| puts "页码:#{book.start} 标注 : #{book.markInfo}" }
      end
    end
  end
end

require 'yinxiang'

yinxiang = YinXiangSDK.new