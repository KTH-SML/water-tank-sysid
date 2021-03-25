function RECIsDone(app)
    if app.REC.wasStoped
        tankFcn.REC_mode(app, false);
        app.REC.wasStoped = false;
    end
end
