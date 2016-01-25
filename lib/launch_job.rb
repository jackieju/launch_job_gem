# launch job
# Author: Jackie.ju@gmail.com

# launch a job with a function, interval
# sometime job need run very freqently and log cost too much compared with running time, in this case should set log=false
require 'rubygems'
require 'ps_grep'

def launch_job_with_hash(hash)
    # symbolize
    hash = hash.inject({}){|m,(k,v)| m[k.to_sym] = v; m}    
    launch_job(hash[:fn], hash[:ms], hash[:log], hash[:before], hash[:error], 
        hash[:unique], hash[:max_error], hash[:name], hash[:debug])
end
def launch_job(fn, ms=nil, log=true, fn_before_launch=nil, error_handler=nil, unique=false, max_error=nil, name=nil, debug=nil)
    if fn.class == Hash
        return launch_job_with_hash(fn)
    end
    ms = 1 if ms == nil
    
    if unique == true 
        if name == nil
            p "unique job must have a name!"
            return
        else
            ar = find_process("_"+name+"_")
            p ar
            if ar && ar.size > 0
                p "Unique job named #{name} already running"
                return
            end
        end
    end
    
    fn= fn.to_s
    Process.detach fork{
          p("Job process #{$$}: #{fn.to_s} ")
          # $PROGRAM_NAME is equal to $0
       
        # sometime the OS limite the length of $0 to its orginal size, so suggest not give name with length > 19
         $0 ="_#{name}_" if name
         # $progname = $0
         # alias $PROGRAM_NAME $0
         # alias $0 $progname

         # trace_var(:$0) {|val| $PROGRAM_NAME = val} # update for ps
          
           
            Object.send(fn_before_launch.to_s) if fn_before_launch
            
           count = 0
           errcount = 0
           tm = 0
           
           while(1)
               tf_start = Time.now.to_f
               if log
                   _tm = Time.now
                   if _tm.to_i - tm.to_i > 600
                        p "[#{_tm}]I'm running.(count=#{count}, err #{errcount})"
                        tm = _tm
                   end
               end
               
               begin

                   Object.send(fn.to_s)

               rescue Exception=>e


                   p "!!Exception when executing job [#{fn.to_s}]: #{e.inspect}"
                   
                   if error_handler
                       r = Object.send(error_handler.to_s, e) 
                       if r
                           p "Job stop"
                           exit
                       end
                   end
                   
                   errcount+=1
                   if max_error !=nil && errcount> max_error
                       p "Error exceed max error number , job quit"
                       exit
                   end
                       
               end
               
               count+=1
               
               int = ms.to_f - (Time.now.to_f - tf_start)
               int = 0.001 if int <= 0
               
               p "sleep #{int}" if debug
               
               sleep(int)
               
               # p "after sleep" if needlog
           end
       }

end

=begin
# test

def start
    p "start job"
    # throw "fafas"
end
def error(e)
    p "error:#{e}"
    return true
end
def before
    p "before job"
end
launch_job({
    :fn=>"start",
    :error=>"error",
    :before=>"before",
    :unique=>true,
    :name=>"xx"
})
=end
