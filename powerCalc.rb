require 'csv'
require 'date'

class Loyal_Kiwi

    attr_accessor :total_cost

    def initialize
        @total_cost = 0
    end

    def get_power_cost
        return 0.2852
    end

    def get_daily_charge
        return 0.8300
    end

    def add_row(rowMap)
        powerUsed = rowMap["value"].to_f
        @total_cost += get_power_cost * powerUsed
    end

    def add_daily_charge(days)
        @total_cost += get_daily_charge * days
        puts "daily cost LK: #{get_daily_charge * days}"
    end
end

class Move_Master

    attr_accessor :total_cost

    def initialize
        @total_cost = 0
    end

    def get_power_cost(datetime)
        case datetime.hour
        when 0...7 
            return 0.1643
        when 7...9
            return 0.3286
    
        when 9...17
            return 0.2169
    
        when 17...21
            return 0.3286
    
        when 21...23
            return 0.2169
    
        when 23
            return 0.1643
        end
    end

    def get_daily_charge
        return 0.5400
    end

    def add_row(rowMap)
        powerUsed = rowMap["value"].to_f
        powerDateTime = DateTime.parse(rowMap["started_at"])
        @total_cost += get_power_cost(powerDateTime) * powerUsed
    end

    def add_daily_charge(days)
        @total_cost += get_daily_charge * days
        puts "daily cost MM: #{get_daily_charge * days}"
    end
end

class Flick_Business
    attr_accessor :total_cost

    def initialize
        @total_cost = 0
    end

    def get_power_cost(datetime)
        weekday = (1..5).member?(datetime.wday)
        peak = (7...21).member?(datetime.hour)
        if (weekday && peak)
            return 0.2752
        else
            return 0.1446
        end
    end

    def get_daily_charge
        return 0.9669
    end

    def add_row(rowMap)
        powerUsed = rowMap["value"].to_f
        powerDateTime = DateTime.parse(rowMap["started_at"])
        @total_cost += get_power_cost(powerDateTime) * powerUsed
    end

    def add_daily_charge(days)
        @total_cost += get_daily_charge * days
        puts "daily cost FB: #{get_daily_charge * days}"
    end
end

loyalKiwi = Loyal_Kiwi.new
moveMaster = Move_Master.new
flick = Flick_Business.new

data = CSV.read('./data/cranford_2021.csv', headers: true)

kilowattCount = 0
for row in data
    rowMap = row.to_h
    kilowattCount += rowMap["value"].to_f
    loyalKiwi.add_row(rowMap)
    moveMaster.add_row(rowMap)
    flick.add_row(rowMap)
end

startDt = DateTime.parse(data[0].to_h["started_at"])
endDt = DateTime.parse(data[-1].to_h["ended_at"])

dayCount = (endDt - startDt).to_i

loyalKiwi.add_daily_charge(dayCount)
moveMaster.add_daily_charge(dayCount)
flick.add_daily_charge(dayCount)

puts "Total days: #{dayCount}"
puts "Total kWh: #{kilowattCount}" 
puts "LoyalKiwi: #{loyalKiwi.total_cost}"
puts "MoveMaster: #{moveMaster.total_cost}"
puts "Flick Business: #{flick.total_cost}"
