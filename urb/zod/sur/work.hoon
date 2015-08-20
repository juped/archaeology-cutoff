/-    talk
|%
++  client
  $:  tasks=(map ,@uvH client-task)
      sort=(list ,@uvH)
  ==
++  client-task
  $:  claiming=_|
      audience=(set station:talk)
      task=task
  ==
++  task
  $:  id=@uvH
      date-created=@da
      version=@u
      date-modified=@da
      owner=@p
      status=status
      tags=(set ,@t)
      date-due=(unit ,@da)
      done=(unit ,@da)
      title=@t
      description=@t
      discussion=(list comment)
  ==
++  comment
  $:  date=@da
      ship=@p
      body=@t
  ==
++  status  ?(%announced %released %accepted)
++  command  
  $%  [%new audience=(set station:talk) task]
      [%old id=@uvH version=@u dif=update]
      [%sort p=(list ,@uvH)]
  ==
++  update
  $%  $:  %set
  $%  [%date-due p=(unit ,@da)]
      [%title p=@t]
      [%description p=@t]
      [%tags p=(set ,@t)]
      [%done p=?]
      [%audience p=(set station:talk)]
  ==  ==
      $:  %add
  $%  [%comment @t]
  ==  ==
      $:  %own
  $%  [%announce ~]
      [%claim ~]
  ==  ==
  ==
--
