using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Lab11.DataContext;
using Lab11.ViewModels;

namespace Lab11.Controllers
{
    public class StudentController : Controller
    {
        private IDataContext _dataContext;

        public StudentController(IDataContext dataContext)
        {
            _dataContext = dataContext;
        }

        [Route("Students")]
        public ActionResult Index()
        {
            return View(_dataContext.ListStudents());
        }

        [Route("Details/{id}")]
        public ActionResult Details(int id)
        {
            return View(_dataContext.GetStudent(id));
        }

        [Route("Create")]
        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("Create")]
        public ActionResult Create(StudentViewModel student) // change of parameter, data binding
        {
            try
            {
                if (ModelState.IsValid)
                    _dataContext.AddStudent(student);
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        [Route("Edit/{id}")]
        public ActionResult Edit(int id)
        {
            return View(_dataContext.GetStudent(id));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("Edit/{id}")]
        public ActionResult Edit(int id, StudentViewModel value)
        {
            System.Diagnostics.Debug.WriteLine(id);
            try
            {
                if (ModelState.IsValid)
                { 
                    _dataContext.UpdateStudent(id, value);
                    
                }
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        [Route("Delete/{id}")]
        public ActionResult Delete(int id)
        {
            return View(_dataContext.GetStudent(id));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("Delete/{id}")]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                _dataContext.RemoveStudent(id);
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
