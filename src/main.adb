with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;


procedure Main is

   amountOfThreads: Integer;
   last: Natural;
   inputText: String (1 .. 80);
   step: Integer;
   type MathTask is array (Integer range 0 .. 20) of Integer;
   isRunning: Boolean := True;
   mathTasks: MathTask;

   procedure ToString(id: Integer;
                      amount: Long_Long_Integer ;
                      result: Long_Long_Integer ;
                      step: Integer);

   procedure ToString(id: Integer;
                      amount: Long_Long_Integer ;
                      result: Long_Long_Integer ;
                      step: Integer) is
   begin
      Put_Line(Character'Val(10) & "Id thread: " & id'image &
                 Character'Val(10) & "Amount of iterations: " & amount'image &
                 Character'Val(10) & "Result of calc: " & result'image &
                 Character'Val(10) & "Step: " & step'image &
                 Character'Val(10) & "======================================================");

   end ToString;

   task type CalculateProgressionThread(id: Integer; step: Integer);
   task type TaskScheduler;

   task body CalculateProgressionThread is
      result: Long_Long_Integer  := 0;
      amountOfIteration: Long_Long_Integer  := 0;
   begin
      while(isRunning) loop
         result := result + Long_Long_Integer'Value(step'image);
         amountOfIteration := amountOfIteration + 1;
      end loop;
      ToString(id, amountOfIteration, result, step);

   end CalculateProgressionThread;

   task body TaskScheduler is
   begin
      delay 3.0;
      isRunning:= False;
   end TaskScheduler;

   type SchedulerPtr is access all TaskScheduler;
   type CalcProgressPtr is access all CalculateProgressionThread;

   calcThead: CalcProgressPtr;
   scheduler: SchedulerPtr;

   procedure FreeSchedulerObj is new Ada.Unchecked_Deallocation(TaskScheduler, SchedulerPtr);
begin

   Put("Write amount of threads: ");
   Get_Line(inputText, last);
   amountOfThreads := Integer'value(inputText(1..last));

   for i in 1 .. amountOfThreads loop
      Put("Write an step of regression: ");
      Get_Line(inputText, last);
      step := Integer'value(inputText(1..last));
      mathTasks(i) := step;
   end loop;

   for i in 1 .. amountOfThreads loop
      calcThead := new CalculateProgressionThread(i, mathTasks(i));
   end loop;

   scheduler := new TaskScheduler;
   FreeSchedulerObj(scheduler);
end Main;
