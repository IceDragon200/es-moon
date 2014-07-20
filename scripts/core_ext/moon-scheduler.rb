module Moon
  class SchedulerJob
    attr_writer :tag

    def tag(*args)
      args.size > 0 ? (@tag = args.first; self) : @tag
    end
  end

  class Scheduler
    def p_job_table
      table = []
      colsizes = [0, 0, 0, 0]
      @jobs.each do |job|
        # job type, time, duration
        row = [job.class.to_s, job.time.to_s, job.duration.to_s, job.tag.to_s]
        row.size.times do |i|
          size = row[i].size
          colsizes[i] = size if colsizes[i] < size
        end
        table << row
      end
      format = colsizes.map { |i| "%-0#{i}s" }.join("    ")
      puts sprintf(format, "Job", "Time", "Duration", "Tag")
      table.each do |row|
        puts sprintf(format, *row)
      end
    end
  end
end
